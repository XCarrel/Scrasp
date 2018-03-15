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

        [Display(Name = "Titre")]
        public object title;
        [Display(Name = "Description")]
        public object projectDescription;
        [Display(Name = "Repository")]
        public object refRepo;
        [Display(Name = "Stories")]
        public object Stories;
        [Display(Name = "Teams")]
        public object Teams;
    }

    [MetadataType(typeof(ProjectMetadata))]
    public partial class Project
    {
    }

}