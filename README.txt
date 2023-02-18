####Goal: share data from pandostor with collaborator
#pandostor is just an example here, and this would be the similar for firefly, or any other data on malinche
#also from data on Biostorage1 would be the same

###Make sure you have access to Globus 
email hpc-support@columbia.edu and ask them to add you to the Columbia University Globus Group

#################
#some basics
Globus moves data between "endpoints", now called "Collections".
The endpoints for the resources you'll be using for transferring data need to be added to your account.
After logging into the globus.org website, click on "File Manager" and type "Columbia" into the "Collections" field.

GLOBUS PERSONAL
If you're copying to your own machine, you will need to create your own endpoint on the machine from which or to which you will be transferring data to and from Habanero.
In order to do this, you'll need to download and run 'Globus Connect Personal' as described in:

https://www.globus.org/globus-connect-personal

Choose between Mac, Linux, or Windows, and follow the instructions for the download.

Once you run the downloaded software, you will be able to, via the online interface, enter the two endpoints of your transfer, specify the paths of the files/directories on the source and destination systems, and launch the transfer.
Once it starts, it will take place in the background and you do not need to supervise it or even be logged in.

However, please keep in mind that your access to some systems would need to be authenticated, and then possibly re-authenticated at times.

SENSITIVE DATA WARNING
Please note that sensitive data of any kind (PII, PHI, confidential, or otherwise) is NOT permitted for use with Globus.
Globus is not certified for sensitive data of any kind and can only be used for non-sensitive, non-confidential, and otherwise unrestricted data, as specified by the Columbia University Data Classification Policy.

#####################
#How to actually copy the data

#1) copy the data to Terremoto (Globus is still not installed in Ginsburg as far as I can see on Oct-22, but check with hpc support)
#this is necessary because they have globus installed (and it is nearly impossible to set up locally; also its actually blocked from Biostorage1)

#ssh into server where the data is from the terminal

ssh admin@pandostor.biology.columbia.edu

#go to where the data is 
cd /volume1/share/data/guest

#2) copy to desired location in terremoto
#the first time you need to say  you sure you want to continue connecting 

scp -r Briscoe ap3815@moto.rcs.columbia.edu:/moto/palab/users/ap3815/

#for things that take a long time, and so could fail if the connection is cut is better to use rsync as it picks up the transfer from where it left
#so this would be 
rsync -avzp Briscoe ap3815@moto.rcs.columbia.edu:/moto/palab/users/ap3815/

#exit pandostor after everything finishes transfer

exit 
 
#3) log into ginsburg and cd to location just to check everything is there

ssh ap3815@burg.rcs.columbia.edu

cd /burg/palab/users/ap3815/

##################
#How to set up sharing 

#1) in a web browser do
https://www.globus.org

#choose institutional log in and then continue with DUO

#2)Go the File Manager tab on the left and then type "Columbia"

#3) Select Columbia Terremoto from the list
#this is your home dir 

#4) The copy and past the path of where the file you want to share is  to the "Path" section under Collection 
#For example 
/moto/palab/users/apinharanda/

#again you should see exactly the same of what you see in your scratch space 

#5) select the directory you want to share and then click on share on the right part of the screen
This will display any collections you have shared 

#6) to share a new one, select "Add Shared Endpoint"
The path should be automatically filled in, add the other information 
"Share display name" is the name that will then appear next time in 5)

Then click on "Create Share"

#7) You should be now under "Permissions"
Click on the top right on "Add Permissions - Share With"

#Dont change the path in this page, just fill in the rest.
Usually select "share with user"
Add email of the person + message etc 
Save, add permissions 

#8) the person should have gotten an email about it and if they have access to globus they will be able to easily download it to their university server where it is installed/they can log in





