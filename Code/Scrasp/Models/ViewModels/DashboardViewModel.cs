using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Scrasp.Models
{
    public class DashboardViewModel
    {
        public List<Project> myProjects;    // The projects I'm involved in
        public List<Job> myJobs;            // The tasks I have within those
    }
}