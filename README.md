## Overview

This repository contains part of the works I've been doing with Massachusetts Open Cloud project (MOC). Please see our [github](https://github.com/CCI-MOC) and [official website](http://www.bu.edu/hic/research/massachusetts-open-cloud/) for more information

The main projects that I'm working on are:
* Openstack Mix&Match Federation
  * see our [public wiki](https://github.com/CCI-MOC/moc-public/wiki/Mix-and-Match-Federation) page for more detail
  * Keystone to Keystone federation
  * Using K2K federation to do application between 2 openstacks, such as using attach volume from remote cinder (in Service Provider) to a local instance (in Identity Provider)
    * demoed in keystone-midcycle
  * We are planning to present this on the Tokyo openstack summit in October

* BigData As A Service (BDAAS)
  * This project started on July 2015. It is more of a research project on eximinating the difference in performance of a **virtual** hadoop cluster in terms of power consumtion, cpu usage, running time, etc with different hadoop components.
  * MOC provides administrative privilege to support a throughout and detailed data collection
  * This research requires a fast and easy deployment of hadoop clusters with many machines (tens? hundreds?) on openstack. I created a 1-click hadoop cluster deployment, that deploys multiple hadoop clusters in parallel. This effort in in the progress of upstreaming to [apache/bigtop](https://github.com/apache/bigtop)see [BIGTOP-1911](https://issues.apache.org/jira/browse/BIGTOP-1911) for detail  
##
