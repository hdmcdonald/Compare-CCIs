# Compare CCIs
Preprint coming soon! The link to BioRxiv and full code repository will be posted here!

In the meantime, see our poster at ISPGR 2025 and some additional details and figures below:

## Generation of Synthetic EMG data:
<img width="322" alt="randomSyntheticEMG" src="https://github.com/user-attachments/assets/a55a6f9b-869b-45ea-971a-06cbdfe65da5">

*Figure 1 - Examples of randomly generated synthetic EMG*

For correlations between CCIs, we generated 3000 pairs of randomly generated synthetic EMG: 
* 1000 pairs of linear functions
* 1000 pairs of 2nd order polynomials
* 1000 pairs of sinusoids

All synthetic EMG signals were rectified to remove negative values; signals with a maximum amplitude greater than 1 were scaled to span 0 to 1

## Effects of Amplitude Normalization: 

<img width="322" alt="ampNorm" src="https://github.com/user-attachments/assets/d12aa69b-757b-4196-a838-64afe6d092e2">

_Figure 2_

Amplitude normalization of EMG signals to a maximum reference value enables meaningful comparisons across muscles, participants, and measurement sessions [24]. The choice of amplitude normalization technique depends on the intended analysis and interpretation [24,25]. To assess how different amplitude normalization techniques affect CCIs, three pairs of synthetic EMG signals described above were modified to have peak amplitudes that were consistent, in theory, with those created by different amplitude normalization methods [24]: i) amplitudes ranging from 0 to 0.6, _consistent with normalization to a maximum voluntary contraction or m-wave;_ ii) amplitudes ranging from 0 to 1, _consistent with normalization to a within-task maximum;_ and iii) amplitudes ranging from 0 to 1.4, _consistent with non-normalized EMG data._ We then examined how these differences in signal amplitude that would be created by different normalization techniques influenced co-contraction values calculated using the indices described in Figure 1.

EMG amplitude normalization techniques appear to influence ratio and amplitude-driven CCIs differently depending on whether they alter the amplitude of EMGlow - and thus the overlap between two EMG signals - and/or the total EMG activity (i.e., the sum of two EMG signals) (Figure 2). When normalization techniques alter both the amplitude of EMGlow and the total EMG activity, amplitude-driven CCIs rather than ratio-based CCI appear to be affected the most (Figure 2A). Relative to non-normalized synthetic EMG data (dotted line, Figure 2A), decreases in the amplitude of EMG2 (i.e., EMGlow) that are consistent with within-task (dot-dashed line) and MVC-based amplitude normalization (dashed line) reduces the overlap between EMG1 and EMG2 while also slightly reducing total EMG activity. The decrease in EMGlow lowers the numerator of the amplitude-driven CCIs, thereby decreasing their overall value. Although the numerator of ratio-based CCIs is also affected, the concurrent decrease in total EMG activity – the denominator in ratio-based CCIs - offsets this reduction and results in minimal change to the ratio of EMGlow to EMGhigh, and thus ratio-based CCIs (Figure 2A).

When only one of total EMG activity or EMGlow is altered by amplitude normalization, the ratio of EMGlow to EMGhigh is modified, and there is a large change in ratio-based CCIs (Figure 2B-C). Amplitude-driven CCIs are affected if EMGlow is altered (Figure 2B), while changes to EMGhigh have little effect on CCI (Figure 8C). For example, the decrease in the amplitude of EMG2 (i.e., EMGhigh) in Figure 8C that accompanies within-task (dot-dashed line) and MVC-based normalization (dashed line) reduces the total EMG activity but has no effect on the overlap between EMG1 and EMG2 causing a large decrease in the denominator of ratio-based CCIs, and thus an increase in their overall value. A change in total muscle activity alone has minimal effect on amplitude-driven CCI values because they are sensitive to changes in signal overlap, which depends on the amplitude of EMGlow.

Changes in EMG amplitude due to the choice of normalization technique are largely irrelevant to temporal CCIs because they depend on EMG onset and offset times relative to a low-level threshold rather than signal amplitude. 

The analysis presented here suggests that relative to non-normalized EMG data, changes in EMG amplitude that are consistent with MVC and within-task amplitude normalization methods appear to decrease amplitude-driven CCIs, but not ratio-based CCIs as the amplitude of EMGlow (i.e., the overlap between EMG1 and EMG2) and the total EMG activity decreases. If only total EMG activity is affected, MVC and within-task amplitude normalization appears to increase the magnitude of ratio-based CCI values, with little effect on amplitude-drive CCI values. Careful consideration for the amplitude normalization method selected, the type of CCI to which it is applied, and whether the effects of the chosen technique are limited to the total EMG activity or also include the overlap between two EMG signals are all important factors that determine whether and in which direction amplitude normalization alters our estimates of muscle co-contraction.

## Proposal: Consider scaling co-contraction values to the theoretical maximum of their index to facilitate comparisons between indices and studies.

<img width="322" alt="proposalFig1" src="https://github.com/user-attachments/assets/c7ddafe9-ec5a-47cc-87ac-4413cc5fbf0d">

_Figure 3_

The range of behaviors and possible values for each CCI suggests that different indices should not be directly compared. Figure 3 illustrates how co-contraction values differ across indices by comparing values derived from each index during minimum, moderate, and maximum overlap between two EMG signals. In Figure 3A, only one muscle is active at a time (i.e., no overlap), and all CCIsThe theoretical maximum of a CCI (CCImax) occurs when the agonist and antagonist EMG signals are equal, meaning both EMG1 and EMG2 are set to EMGhigh (represented by black outline bars in Figure 5, middle column). For ratio-based CCIs (e.g., CCIFalconer), CCImax always equals 1 because these indices quantify the similarity in shape of two EMG signals. For the amplitude-driven and temporal indices, CCImax depends on the magnitude of the higher of the two EMG signals. CCImax can be calculated for each index by setting both EMG1 and EMG2 to EMGhigh. The scaled CCI can then be calculated as 𝐶𝐶𝐼𝑠𝑐𝑎𝑙𝑒𝑑=𝐶𝐶𝐼/𝐶𝐶𝐼𝑚𝑎𝑥×100% (illustrated in right column, Figure 3). This scaling method provides more equivalence among indices, enabling direct comparisons between said indices and across studies. We therefore recommend reporting co-contraction values as a percentage of their CCImax.

## Included function: Calculating co-contraction indices using 5 common formulas
