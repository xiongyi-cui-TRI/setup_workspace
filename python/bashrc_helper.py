import cmdUtil

homeDir = cmdUtil.getHomeDir()
BASHRC_FILE = homeDir + '.bashrc'


def sourceFileInBashrc(file_full):
    cmdUtil.appendToFile(BASHRC_FILE, 'source ' + file_full + '\n')


def makeBashFunction(functionName, functionContent):
    return '''
    function  {}()
    {
    {}
    }\n
    '''.format(functionName, functionContent)
