# docker_gitandawscli

# Build
    docker build -t gitandawscli --build-arg proxy='http://SERVER:PORT' .

# Run and play
     docker run -tid --name prueba -p 22:22 gitandawscli 