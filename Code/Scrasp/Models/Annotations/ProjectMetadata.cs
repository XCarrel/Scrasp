using System.ComponentModel.DataAnnotations;

namespace Scrasp.Models {
    public class ProjectMetadata {
        [Display(Name = "Titre")]
        [MinLength(4, ErrorMessage = "Le titre doit contenir entre 4 et 50 caractères")]
        [MaxLength(50, ErrorMessage = "Le titre doit contenir entre 4 et 50 caractères")]
        [Required(ErrorMessage = "Le titre est obligatoire")]
        public object title { get; set; }

        [Display(Name = "Description du projet")]
        [MinLength(50, ErrorMessage = "La description doit contenir au minimum 50 caractères")]
        [Required(ErrorMessage = "La description est obligatoire")]
        public object projectDescription { get; set; }

        [Display(Name = "Repository Git")]
        [Url(ErrorMessage = "Le repository doit être une URL valide")]
        public object refRepo { get; set; }

        [Display(Name = "Date de début")]
        [DataType(DataType.Date)]
        public object beginDate;

        [Display(Name = "Date de fin")]
        [DataType(DataType.Date)]
        public object endDate;
    }

    [MetadataType(typeof(ProjectMetadata))]
    public partial class Project { }
}