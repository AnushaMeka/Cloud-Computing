echo "select the resources needed for launching an instance"

echo "List of instances present:"
openstack server list --insecure
#echo "please enter #VM's you want to create"
#read NUM_OF_VM
echo "please enter a VM name of your choice"
read INSTANCE_NAME

echo "List of images present:"
openstack image list --insecure
echo "please select an image from the list above"
read IMAGE_NAME

echo "List of Flavors:"
openstack flavor list --insecure
echo "please select a flavor fro the list above"
read FLAVOR_NAME

echo "List of Networks:"
openstack network list --insecure
echo "Please select a network from the list above"
read NETWORK_NAME

#echo "List of Keypairs:"
#openstack keypair list --insecure
echo "please enter a key name:"
read KEY_NAME

openstack keypair create $KEY_NAME > ~/$KEY_NAME --insecure
chmod 600 ~/$KEY_NAME

#VM_NAME="$INSTANCE_NAME"
#echo "Creating VM - $i"

openstack server create --key-name $KEY_NAME --image $IMAGE_NAME --flavor $FLAVOR_NAME --network $NETWORK_NAME $INSTANCE_NAME --insecure
echo "Associating floating IP to the created VM. It takes few seconds."
FLOATING_IP=$(openstack floating ip create public --insecure | grep floating_ip_address | awk '{print $4}')
openstack server add floating ip $INSTANCE_NAME "$FLOATING_IP" --insecure
echo "Listing the servers. It may show status as BUILD for the newly created vm."
echo "Try to execute the command (openstack server list --insecure) again and confirm that its status changed to ACTIVE"
openstack server list --insecure
