using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Scrasp.Models
{
    public class DashboardViewModel
    {
        public List<Project> userProjects; // all projects of the current connected user
        public List<Job> userJobs; // all jobs of the current connected user
    }
}