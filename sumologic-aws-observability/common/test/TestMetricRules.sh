#!/bin/bash

export AWS_REGION="us-east-1"
export AWS_PROFILE="personal"
# App to test
export AppTemplateName="metric_rules"
export AppName="metricrules"
export InstallTypes=("all")

for InstallType in "${InstallTypes[@]}"
do
    export AddMetricRuleForALB="No"
    export AddMetricRuleForAPIGateway="No"
    export AddMetricRuleForRDS="No"
    export AddMetricRuleForEC2Metrics="No"
    export AddMetricRuleForLambda="No"
    export AddMetricRuleForDynamoDB="No"

    if [[ "${InstallType}" == "ec2" ]]
    then
        export AddMetricRuleForEC2Metrics="Yes"
    elif [[ "${InstallType}" == "all" ]]
    then
        export AddMetricRuleForALB="Yes"
        export AddMetricRuleForAPIGateway="Yes"
        export AddMetricRuleForRDS="Yes"
        export AddMetricRuleForEC2Metrics="Yes"
        export AddMetricRuleForLambda="Yes"
        export AddMetricRuleForDynamoDB="Yes"
    else
        echo "No Choice"
    fi

    # Export Sumo Properties
    export SumoAccessID=""
    export SumoAccessKey=""
    export SumoOrganizationId=""
    export SumoDeployment="nite"
    export RemoveSumoResourcesOnDeleteStack=true

    # Export Tags Details
    export AccountAlias="Hello"

    export template_file="${AppTemplateName}.template.yaml"

    aws cloudformation deploy --profile ${AWS_PROFILE} --template-file ././../sam/${template_file} \
    --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND --stack-name "${AppName}-${InstallType}" \
    --parameter-overrides SumoDeployment="${SumoDeployment}" SumoAccessID="${SumoAccessID}" SumoAccessKey="${SumoAccessKey}" \
    SumoOrganizationId="${SumoOrganizationId}" RemoveSumoResourcesOnDeleteStack="${RemoveSumoResourcesOnDeleteStack}" \
    AddMetricRuleForALB="${AddMetricRuleForALB}" AddMetricRuleForAPIGateway="${AddMetricRuleForAPIGateway}" \
    AddMetricRuleForRDS="${AddMetricRuleForRDS}" AddMetricRuleForEC2Metrics="${AddMetricRuleForEC2Metrics}" \
    AddMetricRuleForLambda="${AddMetricRuleForLambda}" AddMetricRuleForDynamoDB="${AddMetricRuleForDynamoDB}" AccountAlias="${AccountAlias}"

done

echo "All Installation Complete for ${AppName}"