using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Scrasp.Models
{
    /// <summary>
    /// Model for the team management table
    /// </summary>
    public class TeamManagementViewModel
    {
        public List<Project> projects; // all projects
        public List<ScraspUser> users; // all users
        public List<Team> teams;       // who's in which project
    }
}