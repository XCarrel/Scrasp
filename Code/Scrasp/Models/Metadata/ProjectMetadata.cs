using System.ComponentModel.DataAnnotations;

namespace Scrasp.Models {
    public class ProjectMetadata {
        [Display(Name = "Project Identification")]
        public object id;
        [Display(Name = "Title")]
        public object title;
        [Display(Name = "Project Description")]
        public object projectDescription;
        [Display(Name = "Git Repository")]
        public object refRepo;
    }

    [MetadataType(typeof(ProjectMetadata))]
    public partial class Project {
    }
}