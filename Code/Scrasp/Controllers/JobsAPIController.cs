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

namespace Scrasp.Controllers
{
    public class JobsAPIController : ApiController
    {
        private scraspEntities db = new scraspEntities();

        // GET: api/JobsAPI
        public IQueryable<Job> GetJobs()
        {
            return db.Jobs;
        }

        // GET: api/JobsAPI/5
        [ResponseType(typeof(Job))]
        public IHttpActionResult GetJob(int id)
        {
            Job job = db.Jobs.Find(id);
            if (job == null)
            {
                return NotFound();
            }

            return Ok(job);
        }

        // PUT: api/JobsAPI/5
        [ResponseType(typeof(void))]
        public IHttpActionResult PutJob(int id, Job job)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != job.id)
            {
                return BadRequest();
            }

            db.Entry(job).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!JobExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return StatusCode(HttpStatusCode.NoContent);
        }

        // POST: api/JobsAPI
        [ResponseType(typeof(Job))]
        public IHttpActionResult PostJob(Job job)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.Jobs.Add(job);
            db.SaveChanges();

            return CreatedAtRoute("DefaultApi", new { id = job.id }, job);
        }

        // DELETE: api/JobsAPI/5
        [ResponseType(typeof(Job))]
        public IHttpActionResult DeleteJob(int id)
        {
            Job job = db.Jobs.Find(id);
            if (job == null)
            {
                return NotFound();
            }

            db.Jobs.Remove(job);
            db.SaveChanges();

            return Ok(job);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool JobExists(int id)
        {
            return db.Jobs.Count(e => e.id == id) > 0;
        }
    }
}