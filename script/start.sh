#!/bin/bash -x
echo “Starting Dev Environment”

if [[ $# -eq 0 ]] ; then
 echo ‘You need to pass in a string name for your scratch org’
 exit 1
fi

echo “Creating a new scratch org”
sfdx force:org:create -s -f config/project-scratch-def.json -a $1
echo “Pushing project to scratch org”
sfdx force:source:push -u $1
echo Import test data”
sfdx force:data:tree:import --plan data/data-plan.json
echo “Open scratch org”
sfdx force:org:open -u $1