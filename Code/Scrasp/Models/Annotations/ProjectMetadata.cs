using System.ComponentModel.DataAnnotations;

namespace Scrasp.Models {
    public class ProjectMetadata {
        [Display(Name = "Titre")]
        [MinLength(4, ErrorMessage = "Minimum 4 caractères")]
        [MaxLength(50, ErrorMessage = "Maximum 50 caractères")]
        [Required(ErrorMessage = "Champ obligatoire")]
        public object title;

        [Display(Name = "Description du projet")]
        [MinLength(50, ErrorMessage = "Minimum 50 caractères")]
        [Required(ErrorMessage = "Champ obligatoire")]
        public object projectDescription;

        [Display(Name = "Repository Git")]
        [Url(ErrorMessage = "N'est pas une URL valide")]
        public object refRepo;

        [Display(Name = "Date de début")]
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        [DataType(DataType.Date)]
        public object startDate;

        [Display(Name = "Date de fin")]
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        [DataType(DataType.Date)]
        public object endDate;
    }

    [MetadataType(typeof(ProjectMetadata))]
    public partial class Project { }
}