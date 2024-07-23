FROM google/cloud-sdk

# Define o diretório de trabalho
WORKDIR /cleanup

# Instala o jq para manipulação de JSON
RUN apt-get update && apt-get install -y jq

# Copia o script de limpeza e outros arquivos necessários para o contêiner
COPY delete-orphaned-kube-network-load-balancers.sh /cleanup/delete-orphaned-kube-network-load-balancers.sh
COPY entrypoint.sh /cleanup/entrypoint.sh
COPY lib /cleanup/lib

# Define permissões de execução para o script
RUN chmod +x /cleanup/delete-orphaned-kube-network-load-balancers.sh /cleanup/entrypoint.sh

# Define o entrypoint para o contêiner
ENTRYPOINT ["/cleanup/entrypoint.sh"]
