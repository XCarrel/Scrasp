using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Scrasp.Models
{
    public class DashboardViewModels
    {
        public List<Project> projects;  // all projects
        public List<Job> jobs;          // all jobs (tasks)
        public List<Team> teams;        // to know who is in thich project
        public ScraspUser loggedUser;
    }
}