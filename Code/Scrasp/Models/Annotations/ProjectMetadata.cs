using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace Scrasp.Models
{
    public class ProjectMetadata
    {
        public object id { get; set; }
        [Display(Name = "Titre")]
        public object title { get; set; }
        [Display(Name = "Description")]
        public object projectDescription { get; set; }
        [Display(Name = "repo")]
        public object refRepo { get; set; }
    }
    [MetadataType(typeof(ProjectMetadata))]
    public partial class Project { }
}