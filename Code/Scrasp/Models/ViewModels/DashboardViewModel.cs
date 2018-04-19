using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Scrasp.Models
{
    public class DashboardViewModel
    {
        public Project project;
        public ScraspUser user;
        public List<Project> projects;
        public List<ScraspUser> users; // all users
        public List<Job> jobs;
        public List<Team> teams;
        public Job job;
        public List<JobState> states;
    }
}