# StrataTrapper

*********************** Field scale model generation and upscaling *********************** <br>
This is a tool to generate heterogenerous fine-scale model with specific correlation legth & <br>
update model for two-phase flow simluation. You should have received a copy of the GNU <br>
along with Sam Krevor (s.krevor@imperial.ac.uk) or Senyou An (s.an@imperial.ac.uk).        <br>
If not, see <http://www.gnu.org/licenses/>.                                                <br> 
********************************************************************************************<br> 

* Code structure <br>
All function codes in the folder (Functions).  <br>
Setting & fluid properties for simuatione in folder (Input). <br>
The visualization and intermediate files are stored in the folder (Output). <br>
The Eclipse running files after upscaling are stored in the folder (Result). <br>
A0_mian.m is the main code. A1--A5.m codes are functions called by A0, and can also be run individually.

* How to run codes <br>
Change parameters in Input floder .<br>
Run A0_mian.m to call all funtions, without need to change other codes. <br>
If users would like to re-run A1--A5.m codes individually, it is also doable.  <br>
The gnerated Eclipse running dataset is based on version 2019. Change it if needed. <br>

* Reference <br>
Please refer to the user guide for more detailed instructions.  <br>
If you want to learn more about the theory behind StrataTrapper, please refer to the following paper(s).  <br>
Jackson, Samuel J., and Samuel Krevor. "Small‐scale capillary heterogeneity linked to rapid plume migration during co 2 storage." Geophysical Research Letters 47.18 (2020): e2020GL088616.
