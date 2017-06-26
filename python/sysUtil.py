import lsb_release

# return example:
# {'RELEASE': '14.04', 'CODENAME': 'trusty', 'ID': 'Ubuntu', 'DESCRIPTION': 'Ubuntu 14.04.5 LTS'}
def getLsb_ReleaseInfo():
	return lsb_release.get_lsb_information()

def isUbuntu():
	return getLsb_ReleaseInfo()['ID'] is 'Ubuntu'

def isUbuntu14LTS():
	return '14.04' in getLsb_ReleaseInfo()['RELEASE'] 

def isUbuntu16LTS():
	return '16.04' in getLsb_ReleaseInfo()['RELEASE'] 
    