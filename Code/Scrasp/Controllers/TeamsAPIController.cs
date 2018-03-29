using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using Scrasp.Models;

namespace Scrasp.Controllers {
    public class TeamsAPIController : ApiController {
        private scraspEntities db = new scraspEntities();

        // GET: api/TeamsAPI
        public IQueryable GetTeams() {
            return db.Teams.Select(team => new {team.Projects_id, team.ScraspUsers_id});
        }

        // GET: api/TeamsAPI/5
        [ResponseType(typeof(Team))]
        public IHttpActionResult GetTeam(int id) {
            Team team = db.Teams.Find(id);
            if (team == null) {
                return NotFound();
            }

            return Ok(team);
        }

        // PUT: api/TeamsAPI/5
        [ResponseType(typeof(void))]
        public IHttpActionResult PutTeam(int id, Team team) {
            if (!ModelState.IsValid) {
                return BadRequest(ModelState);
            }

            if (id != team.id) {
                return BadRequest();
            }

            db.Entry(team).State = EntityState.Modified;

            try {
                db.SaveChanges();
            } catch (DbUpdateConcurrencyException) {
                if (!TeamExists(id)) {
                    return NotFound();
                } else {
                    throw;
                }
            }

            return StatusCode(HttpStatusCode.NoContent);
        }

        // POST: api/TeamsAPI
        [ResponseType(typeof(Team))]
        public IHttpActionResult PostTeam([FromBody] Team team) {
            if (!ModelState.IsValid) {
                return BadRequest(ModelState);
            }
            if (db.ScraspUsers.FirstOrDefault(t => t.id == team.ScraspUsers_id) == null) {
                return NotFound();
            }

            db.Teams.Add(team);
            db.SaveChanges();

            return CreatedAtRoute("DefaultApi", new {id = team.id}, team);
        }

        // DELETE: api/TeamsAPI/
        [ResponseType(typeof(Team))]
        public IHttpActionResult DeleteTeam([FromBody] Team team) {
            var removeTeam = db.Teams.FirstOrDefault(t => t.Projects_id == team.Projects_id && t.ScraspUsers_id == team.ScraspUsers_id);
            if (removeTeam == null) {
                return NotFound();
            }

            var jobs = db.ScraspUsers.Find(team.ScraspUsers_id)?.Jobs;
            if (jobs != null) {
                if (jobs.Any(job => job.Story != null && job.Story.Projects_id == team.Projects_id)) {
                    return Content(HttpStatusCode.Forbidden, "");
                }
            }

            db.Teams.Remove(removeTeam);
            db.SaveChanges();

            return Ok(removeTeam);
        }

        protected override void Dispose(bool disposing) {
            if (disposing) {
                db.Dispose();
            }

            base.Dispose(disposing);
        }

        private bool TeamExists(int id) {
            return db.Teams.Count(e => e.id == id) > 0;
        }
    }
}