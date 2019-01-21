
#!/bin/bash

__create_user() {
# Create a user to SSH into as.
useradd slave
SSH_USERPASS=slaveContainer
echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin slave)
echo ssh slave password: $SSH_USERPASS
}

# Call all functions
__create_user