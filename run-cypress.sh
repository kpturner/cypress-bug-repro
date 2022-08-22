#!/bin/bash

# Run Cypress tests, either headlessly (default) or via the UI 

set -e

function usage {
    echo "Usage: ./run-cypress.sh"
    echo "--target             | -t   [helios(default) or panoptes]"
    echo "--open               | -o   [Runs via the Cypress UI]"
    echo "--config             | -c   [Override cypress config, for example -c video=true     See https://docs.cypress.io/guides/references/configuration.html#Command-Line]"
    echo "--tags               | -a   [Override tags]"
    echo "--spec               | -s   [Run a particular spec like '**/changeDetection.feature']"
    echo "--verbose            | -v   [Run in verbose output mode]"
    echo "--browser            | -b   [Browser: (edge, chrome, firefox, electron]"
}

target="helios"
spec="--spec **/All.features"
verbose=""
browser=""
tags=""
env=""
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -t|--target) target="$2"; shift ;;
        -c|--config) config="--config $2"; shift ;;
        -s|--spec) spec="--spec $2"; shift ;;
        -a|--tags) tags="$2"; shift ;;
        -v|--verbose) verbose=1;;
        -b|--browser) browser="--browser $2"; shift ;;
        -o|--open) open=1 ;;
        *) 
        echo "Unknown parameter passed: $1";
        usage;
        exit 1 ;;
    esac
    shift
done

if [[ $target != "helios" && $target != "panoptes" ]]; then
    usage;
    exit 1;
fi

unset CYPRESS_LOG_TO_OUTPUT
if [[ $verbose ]]; then
    echo Verbose Mode
    export CYPRESS_LOG_TO_OUTPUT=true
    if [[ $browser == "" ]]; then
        browser="--browser chrome"
    fi
fi


export NVM_DIR="$HOME/.nvm"
LOADNVM="/usr/local/opt/nvm/nvm.sh"
if [[ -f $LOADNVM ]]
then
    . $LOADNVM
fi
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

NVMRC=`cat .nvmrc`

nvm use $NVMRC

home='/opt/Fotech/data/HeliosData';
alt_configs='/opt/Fotech/helios/etc/alt_configs'
configs='/opt/Fotech/helios/etc'
models='/opt/Fotech/helios/etc/models'

if [ -d $home ]
then
    sudo rm -rf /opt/Fotech/data/HeliosAcousticData/cypress/*.*
    sudo rm -rf /opt/Fotech/data/HeliosPhaseData/cypress/*.*
    sudo rm -rf $home/cypress
    sudo mkdir $home/cypress
    sudo chown fotechd: $home/cypress

    if [ ! -d $models ]
    then
        sudo mkdir $models
        sudo chown fotechd: $models
    fi
    
    dataPath=cypress/fixtures/data
    sudo cp $dataPath/files/*.* $home/cypress
    sudo cp $dataPath/databases/*.* $alt_configs
    sudo cp $dataPath/models/*.* $models

    configPath=cypress/fixtures/config
    sudo cp $configPath/system_configuration_test.yml $configs
fi

npm i
npm run lint

rm -f -- cypress/screenshots/**/temp*.png

DOTENV=.env
if [ -f "$DOTENV" ]; then
    echo "$DOTENV exists."
    set -o allexport   
    source $DOTENV
    set +o allexport
fi

if [[ $open ]]; then
    npx cypress open $browser $config
elif  [[ $tags == "" ]]; then
    DEBUG=-cypress-log-to-output npx cypress run --headless $browser $verbose $spec $config
else
    DEBUG=-cypress-log-to-output npx cypress run --headless $browser $verbose $spec $config -e TAGS="$tags"
fi

FAILURES=$?
if [[ $FAILURES != "0" ]]; then
    echo We have $FAILURES test failures
    # TODO Take action
    exit 1
fi
