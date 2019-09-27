Medium Post | <a href="https://nbviewer.jupyter.org/github/jchang96/A-Look-into-For-Hire-Vehicles-Accessibility/blob/master/FHV%20Accessibility%20Demand%20Prediction.ipynb">Jupyter Notebook</a>
________________________________________________________________________________________________________________________________________

# A Look into For-Hire Vehicles Accessibility

<br/>
<p>
    <img src="/Images/nyc-taxi-1.png"/>
</p>

By Jean Chang
<br/><br/>

The New York City Taxi and Limousine Commission (TLC) has implemented rules to make New York City accessible to all residents and visitors, including those who use wheelchairs. On December 13, 2017, TLC started requiring For-Hire Vehicle (FHV) bases to dispatch 25% of their trips to wheelchair accessible vehicles (WAVs). This rule, WAV Dispatch, launched in February 2019 and have a total of 601 bases currently in the program with access to 699 FHV WAVs.


<br/>**Comparison to 2018** <br/>

To see the travel patterns of passengers in FHV WAVs, trip data for June 2018 and June 2019 was analyzed. Based on trips made in June 2018, most of the trips were made in Lower Manhattan and parts of Brooklyn and Queens. There was an average of 36 vehicles on the road. Compared to last year, the number of FHV WAVs has increased significantly with an average of 548 vehicles on the road. Now trips are made in Manhattan, Brooklyn, Queens, Bronx and a few in Staten Island. 

<br/>
<p float="left">
    <img src="/Images/June_2018.png" width="425"/>
    <img src="/Images/June_2019.png" width="425"/>
    <em>Left: Trips in 2018<br/>Right: Trips in 2019</em>
</p>

<br/> **Which regions have the most pick-ups and drop-offs?** <br/>

For a closer look on FHV accessibility trips made, pick-up and drop-off locations were analyzed by taxi zones. The data showed that the top 5 pick-up zones are East Harlem South, Central Harlem North, Lenox Hill East, Washington Heights South, located in Manhattan, and Forest Hills, located in Queens. The top 5 drop-off zones are East Harlem South, Washington Heights South, Central Harlem North, Lenox Hill East, located in Manhattan, and Borough Park, located in Brooklyn.

<br/><br/>
<p>
    <img src="/Images/Zone Map.png"/>
    <em>Pick-ups and Drop-offs by Taxi Zones</em>
</p>
<br/>

Top 5 Pick-up Taxi Zones  
<ol type="1">
  <li>East Harlem South, Manhattan</li>
  <li>Central Harlem North, Manhattan</li>
  <li>Lenox Hill East, Manhattan</li>
  <li>Washington Heights South</li>
  <li>Forest Hills, Queens</li>
</ol>

<br/>

Top 5 Drop-off Taxi Zones                                                                                                 
<ol type="1">
  <li>East Harlem South, Manhattan</li>
  <li>Washington Heights South, Manhattan</li>
  <li>Borough Park, Brooklyn</li>
  <li>Central Harlem North, Manhattan</li>
  <li>Lenox Hill East, Manhattan</li>
</ol>

<br/><br/> **Are FHV WAVs serving outer borough as well?** <br/>

Most FHV accessibility trips are performed in Manhattan compared to the other boroughs. In June 2019, there were 3,193 trips in Manhattan which is 38% of all FHV accessibility trips in New York City, followed by Brooklyn with 2,228 trips, Queens with 1,509 trips, Bronx with 1,482 trips, and Staten Island with only 22 trips. 

<p>
    <img src="/Images/Trips Pie Chart.png"/>
    <em>Total Trips by Borough</em>
</p>
<br/>

Trips by Borough                                                                                                          
<ol type="1">
  <li>Manhattan - 38</li>
  <li>Brooklyn - 26%</li>
  <li>Queens - 18%</li>
  <li>Bronx - 18%</li>
  <li>Staten Island - 0.3%</li>
</ol>

<br/>**Demand Predication** <br/><br/>

<p>
    <img src="/Images/Trip Prediction.png"/>
    <em>FHV Accessibility Demand Prediciton</em>
</p>
<br/>

A predictive model was developed to predict future demand of FHV accessibility trips in New York City. As illustrated by the heatmap shown above, trips in Queens will be in more demand. Nonetheless, the FHV Accessibility program will continue to be a reliable service to passengers in wheelchairs. 

<br/><br/>

*Jean Chang is a Data Analyst at the New York City Taxi and Limousine Commission*
