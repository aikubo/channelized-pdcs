# status updates on channelization PDC project

0/23/2019
  stopping mass flow at some time didn't work, consulted Ryan and am testing new method 
  
  updated timeaveraging to use NaNs for heights the flow doesn't reach, but the Richardson numbers still don't work

07/22/2019
  Paul helped me set up non-constant mass inflow, testing to see if it works
  
  pressure balanced run looked okay, set it to run for 60s
  
  edited sbatch submission script immediate do post processing 
  
  running non-constant mass inflow stopping at 10s in debug mode
  
  draft one of AGU abstract
  
07/21/2019
  started scripts to time average vertical profiles
  
  running example run pressure balanced 

07/18/2019
  meeting with J Dufek
  added stuff to do 
  
  goals: pressure balanced, velocity aligned with channel. Get that + scripts to work then run with other slopes/W/D
  
  begin work on AGU abstract
  
07/11/2019
  cleaning out directories to reduce storage
  
  run post processing of dense run and large run
  
  making visualizations of dense run 
  
  updating newsim script

06/5/2019
  continued statistical analysis of topography data
  
  started larger run (400x200x350 IJK)

06/26/2019
  adding more widths/sinuosities in matlab topo generation files

06/20/2019
  running dense flow simulation 
  set inlet to whole channel width, epg 0.9  
  
06/14/2019
  finished rough draft of GRL paper
  statistical analysis of channel

06/7/2019 
  meeting with Joe Dufek 
    discussed topography analysis and expansion of parameter space
    paper draft to be completed June 13
  git created 



# channelized-pdcs

Research Project Abstract

Around explosive volcanic centers such as Mount Merapi, pyroclastic density currents (PDCs) pose a great risk to life and property. Understanding of the mobility and dynamics of PDCs and other gravity currents is vital to mitigating hazards of future eruptions. Evidence from volcaniclastic deposits and one-dimensional modeling suggest that channelization of flows effectively increases run out distances (Bursik & Wood, 1996; Brand et al., 2014). Dense flows are thought to scour and erode the bed leading to confinement for subsequent flows and could result in significant changes to predicted runout distance and mobility. My proposed project will the results of three-dimensional multiphase models comparing confined and unconfined flows using simplified geometries using the methods outlined in Dufek & Bergantz (2007). We will explore how confinement geometries impacts the particle concentration gradient, gas entrainment, and dynamic pressure. In channelized flows, there is significantly less entrainment and higher velocities compared to unconfined flows. We will also investigate sinuous channels and the conditions necessary for channel avulsion and possible mechanisms for overwhelming terrain. 
