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
    }
}