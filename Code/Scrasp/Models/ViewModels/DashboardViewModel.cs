using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Scrasp.Models
{
    /// <summary>
    /// Model for the dashboard view
    /// </summary>
    public class DashboardViewModel
    {
        public List<Team> teams;
        public List<Job> jobs;
        public Job job;
        public Project project;
    }
}