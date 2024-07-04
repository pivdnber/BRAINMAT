# BRAINMAT

## *Analyzing pre-procssed EEG data in Matlab*

> loads EEG data files to analyse human brain activity. The tool enables you to efficiently read and process data files in the .edf file format.

## Table of Contents

- [General Info](https://github.ugent.be/pivdnber/actimat/#general-information)
- [Features](https://github.ugent.be/pivdnber/actimat/#features)
- [Setup](https://github.ugent.be/pivdnber/actimat/#setup)
- [Usage](https://github.ugent.be/pivdnber/actimat/#usage)
- [Technology used](https://github.ugent.be/pivdnber/actimat/#technologies-used)
- [Screenshot](https://github.ugent.be/pivdnber/actimat/#screenshot)
- [Project status](https://github.ugent.be/pivdnber/actimat/#project-status)
- [Acknowledgements](https://github.ugent.be/pivdnber/actimat/#acknowledgements)
- [Conflict of interest](https://github.ugent.be/pivdnber/actimat/#conflicts-of-interest)
- [License](https://github.ugent.be/pivdnber/actimat/#license)
- [Contact](https://github.ugent.be/pivdnber/actimat/#contact)

## General Information

The `MATLAB` code provided in this repository is useful to read and generate results of datasets that have been pre-processed in Brainvision Analyzer 2.2. The script is tested on a set of .edf files which were collected by researchers affiliated with the department of Rehabilitation Sciences at Ghent University. Power calculations of frequency bands of interest are made by means of the *BRAINMAT* script. 

## Features

List of the ready features:

- Select a forlder to read recordings in `.edf`(+) file format
- Depad the imported time series of EEG data 
- Extract the number of epochs of the associated recording
- Perform a frequency analysis
- Loop the subject files organized in a nested parent folder
- Export results to a spreadsheet in a dedicated folder for further statistical analysis 

## Setup

Download the files [here](https://github.com/dx2r/PhD_EEG_Pipeline) and [here](https://github.ugent.be/pivdnber/brainmat): Click **CODE** then **DOWNLOAD ZIP** to save the source files to a secured folder. The downloaded folder should contain the [AnalyzeFrequencies](https://github.ugent.be/pivdnber/EEGACL/tree/main/AnalyzeFrequencies "AnalyzeFrequencies") folder and the following files: brainmat.m, Remove_Padding_From_MAT_File_pvdb.m and NamesEpochs.mat. Sample data have been added for demonstrative purposes, so you can give the tool a spin.

**Paper link:** If you use pieces of the code, please cite the present repository.

## Usage

The matlab code is easy to use. Once the files are downloaded, you can run the application *MATLAB* locally or in the Athena environment. The file `brainmat.m` is the main script that calls on the other scripts and functions in the PhD_EEG_Pipeline folder. Simply run the file

```
brainmat
```

Check out the [scripts](https://github.com/pivdnber/BRAINMAT/AnalyzeFrequencies/brainmat.m)) for more details and operational details.

The script will try to associate imported file names with a number of epochs. Please adjust the file names and epoch numbers in the file NamesEpochs.mat to your needs. And it may be required to relocate the Remove_Padding_And_Retrieve_EpochNumber.m file to the folder *Helper Functions* in the EEG Pipeline folder.

## Technologies Used

- Matlab - successfully tested in versions 2019b and 2020b

## Screenshot

## Project Status

The project has been pauzed and the following areas have room for improvement:

- Animation of the topographic map
- Dynamically importing the file names and the epochs
- Adding more advanced options to the analysis (e.g., source level)

## Acknowledgements

There was no external funding received for this repository. This readme was inspired by ritaly's [README-cheatsheet](https://github.com/ritaly/README-cheatsheet).

## Conflicts of Interest

There are no conflicts of interest relevant to this repository.

## License

> You can check out the full license [here](https://github.com/IgorAntun/node-chat/blob/master/LICENSE)

Brain Research Analysis in Matlab (BRAINMAT) is free but copyright software, distributed under the terms of the **MIT** license. In particular, BRAINMAT is supplied as is. No formal support or maintenance is provided or implied. BRAINMAT is currently developed and maintained by its creator.

## Contact

Created by [Pieter Van den Berghe](pieter.vandenberghe@ugent.be) - feel free to contact me

> I hope that EEGACL will make it easier for researchers to analyse EEG data that is pre-processed in Brainvision Analyzer. Researchers who encounter problems using the script, or have suggestions for additional features, should not hesitate to contact me.
