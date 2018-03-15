using System.ComponentModel.DataAnnotations;

namespace Scrasp.Models {
    public class ProjectMetadata {
        [Display(Name = "Titre")]
        public object title { get; set; }

        [Display(Name = "Description du projet")]
        public object projectDescription { get; set; }

        [Display(Name = "Repository Git")]
        public object refRepo { get; set; }
    }

    [MetadataType(typeof(ProjectMetadata))]
    public partial class Project { }
}