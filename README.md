# doxygen_generate
Batch files to install Doxygen and generate documentation

1- clone this repository<br>
2- copy this folder into the repository you want to doxument<br>
3- run 'doxygen_install.bat'<br>
/!\ graphviz installer doesn't update the PATH environment variable<br>
4- run 'rundll32 sysdm.cpl,EditEnvironmentVariables'<br>
5- add the 'c:\Program Files (x86)\Graphvizyourinstalledversionbecausehavingitinthefoldernameisobviouslyveryimportant\bin' path to PATH<br>
6- restart your computer to make sure it is taken into account (we're just in 2020)<br>
7- run 'doxygen_template_generate.bat' to create a 'yourparentfoldername.doxygen' file<br>
8- run 'doxygen_documentation_generate.bat' to generate the 'html' folder<br>

The 'doxygen.template' file contains common presets injected into 'yourparentfoldername.doxygen' file during the 'doxygen_template_generate' process.
