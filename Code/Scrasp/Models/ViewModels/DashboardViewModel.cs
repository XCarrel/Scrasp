using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Scrasp.Models
{
    public class DashboardViewModel
    {
        //public List<Project> Projects; // all user's projects
        public IEnumerable<Job> Jobs; // all user's jobs
    }
}