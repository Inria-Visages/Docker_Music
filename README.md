## Copy Docker requirements
Clone the repository on your computer

## Install nvidia-docker2 (https://github.com/NVIDIA/nvidia-docker)
  `sudo apt install -y nvidia-docker2`

## github ssh keys
Copy your github ssh keys (with no passphrase in a .ssh folder in the current directory)

## Build image
  `docker build .`

## Run container using nvidia runtime
  `docker run --runtime=nvidia -it CONTAINER_ID`

The CONTAINER_ID is the id displayed at the end of the build process

## Run the pipeline

This Docker contains the music pipeline: 

- pipeline based on a CNN (/music/Anima-Scripts/ms_lesion_segmentation/music_lesion_pipeline/animaMusicLesionSegmentation.py)

## Authors

If you make use fo the pipeline, please cite:

F. Galassi, S. Tarride, E. Vallée, O. Commowick, C. Barillot. Deep learning for multi-site ms lesions segmentation: two-step intensity standardization and generalized loss function. ISBI 2019 - IEEE International Symposium on Biomedical Imaging, Apr 2019, VENICE,Italy. pp.1. Francesca Galassi, Solène Tarride, Emmanuel Vallée, Olivier Commowick, Christian Barillot. Deep learning for multi-site ms lesions segmentation: two-step intensity standardization and generalized loss function. ISBI 2019 - IEEE International Symposium on Biomedical Imaging, Apr 2019, VENICE, Italy. pp.1. ⟨hal-02052250⟩


## License

This project is licensed under the MIT License - see the LICENSE.md file for details

## Acknowledgments

The cascaded CNN architecture at the core of the segmentation step of our pipeline music_v3.2 was proposed by https://github.com/sergivalverde/nicMSlesions. We thank the main author S. Valverde for the positive and helpful discussions.

We thank B<>com, Rennes, for the software development collaboration, essential to translate research work into the clinical practice.

We thank Rennes CHU for the clinical feedback and extensive discussions that have helped optimizing this pipeline so to actually assist clinicians in their practice.

