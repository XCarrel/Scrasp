using System.ComponentModel.DataAnnotations;

namespace Scrasp.Models {
    public class ProjectMetadata {
        [Display(Name = "Titre")]
        [Required(ErrorMessage = "Le {0} est obligatoire")]
        [StringLength(50, MinimumLength = 4, ErrorMessage = "Le {0} doit être entre 4 et 50 caractères")]
        public object title { get; set; }

        [Display(Name = "Description du projet")]
        [Required(ErrorMessage = "La {0} est obligatoire")]
        [StringLength(int.MaxValue, MinimumLength = 50, ErrorMessage = "Le {0} doit être entre 4 et 50 caractères")]
        public object projectDescription { get; set; }

        [Display(Name = "Repository Git")]
        [Url(ErrorMessage = "Doit être un url")]
        public object refRepo { get; set; }

        [Display(Name = "Date de début")]
        [DataType(DataType.Date)]
        public object startDate { get; set; }

        [Display(Name = "Date de fin")]
        [DataType(DataType.Date)]
        public object endDate { get; set; }


    }

    [MetadataType(typeof(ProjectMetadata))]
    public partial class Project { }
}