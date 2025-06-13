# Compare CCIs
Preprint coming soon! The link to BioRxiv and full code repository will be posted here!

In the meantime, see our poster from ISPGR 2025 (link) and some additional details and figures below:

## Generation of Synthetic EMG data:
<img width="322" alt="randomSyntheticEMG" src="https://github.com/user-attachments/assets/a55a6f9b-869b-45ea-971a-06cbdfe65da5">

*Examples of randomly generated synthetic EMG*

For correlations between CCIs, we generated 3000 pairs of randomly generated synthetic EMG: 
* 1000 pairs of linear functions
* 1000 pairs of 2nd order polynomials
* 1000 pairs of sinusoids

All synthetic EMG signals were rectified to remove negative values; signals with a maximum amplitude greater than 1 were scaled to span 0 to 1

## Effects of Amplitude Normalization: 
here brief text about amplitude normalization

<img width="322" alt="ampNorm" src="https://github.com/user-attachments/assets/d12aa69b-757b-4196-a838-64afe6d092e2">

## Proposal: Consider scaling co-contraction values to the theoretical maximum of their index to facilitate comparisons between indices and studies.
more detailed illustration and brief text about scaling CCI to theoretical maximum

<img width="322" alt="proposalFig1" src="https://github.com/user-attachments/assets/c7ddafe9-ec5a-47cc-87ac-4413cc5fbf0d">

## Included function: Calculating co-contraction indices using 5 common formulas
