 az acr create --resource-group $(rgName) --name $(acr-username) --sku Standard --admin-enabled true

          acrUsername=$(az acr credential show --name $(acr-username) --resource-group $(rgName) --query "username" --output tsv)

          acrPassword=$(az acr credential show --name $(acr-username) --resource-group $(rgName) --query "passwords[0].value" --output tsv)

          az appservice plan create --resource-group $(rgName) --name "$(azureWebAppName)-Plan" --sku S1

          az webapp create --resource-group $(rgName) --name $(azureWebAppName) --plan "$(azureWebAppName)-Plan" --deployment-container-image-name "app:latest"

          az webapp deployment slot create --resource-group $(rgName) --name $(azureWebAppName) --slot dev

          az webapp config container set --resource-group $(rgName) --name $(azureWebAppName) --docker-custom-image-name "$(acr-username).azurecr.io/app:latest"

          az webapp config container set --resource-group $(rgName) --name $(azureWebAppName) --docker-registry-server-url "https://$(acr-username).azurecr.io" --docker-registry-server-user $acrUsername --docker-registry-server-password $acrPassword
