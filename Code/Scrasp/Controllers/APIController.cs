using System.Web.Mvc;
using Scrasp.Models;

namespace Scrasp.Controllers
{
    public class APIController : Controller
    {

        private scraspEntities db = new scraspEntities();

        // POST: API
        [HttpPost]
        public string addTeams()
        {
            int projectId = int.Parse(Request["projectId"]);
            int userId = int.Parse(Request["userId"]);

            Team newTeam = new Team();
            newTeam.Projects_id = projectId;
            newTeam.ScraspUsers_id = userId;

            db.Teams.Add(newTeam);
            db.SaveChanges();

            return "Project : "+projectId+" user: "+userId;
        }
    }
}