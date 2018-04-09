using System.Web.Mvc;
using Scrasp.Models;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;

namespace Scrasp.Controllers
{
    public class APIController : Controller
    {

        private scraspEntities db = new scraspEntities();

        // POST: API
        [HttpPost]
        public int toggleUserTeam(int projectId, int userId)
        {
            int res = 0; // result

            // Find user-team association
            List<Team> teams = db.Teams.ToList();
            Team membership = teams.Find(t => t.Projects_id == projectId && t.ScraspUsers_id == userId);

            if (membership == null) // create association
            {
                membership = new Team();
                membership.Projects_id = projectId;
                membership.ScraspUsers_id = userId;
                db.Teams.Add(membership);
                res = 1;
            }
            else // remove it - or not
            {
                bool cango = true; // Let's assume he can leave the project

                // Check if he's on jobs of the project
                foreach (Job j in db.Jobs.Where(j => j.ScraspUsers_id == userId).ToList())
                    if (j.Story != null && j.Story.Project != null && j.Story.Project.id == projectId)
                    {
                        cango = false;
                        break; // no need to carry on
                    }
                if (cango)
                    db.Teams.Remove(membership);
                else
                    res = 2; // leaving denied
            }
            db.SaveChanges();
            return res;
        }
    }
}