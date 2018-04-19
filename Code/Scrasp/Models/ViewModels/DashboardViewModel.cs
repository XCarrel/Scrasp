using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Scrasp.Models {
    /// <summary>
    /// Model for the dashboard of a user
    /// </summary>
    public class DashboardViewModel {
        public List<Project> Projects;  // All user projects
        public List<Job> Jobs;          // All user jobs
    }
}