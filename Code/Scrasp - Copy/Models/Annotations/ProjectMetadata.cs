using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Scrasp.Models {
    public class ProjectMetadata {
        [Display(Name = "Titre")]
        [Required(ErrorMessage = "Le nom du projet est obligatoire")]
        [MinLength(5), MaxLength(50)]
        public object title { get; set; }

        [Display(Name = "Description du projet")]
        [Required(ErrorMessage = "La description du projet est obligatoire")]
        [MinLength(50)]
        public object projectDescription { get; set; }

        [Display(Name = "Repository Git")]
        [Url]
        public object refRepo { get; set; }

        [Display(Name = "Date de début")]
        [DisplayFormat(DataFormatString = "{0:dd MMM yyyy}")]
        [GreaterThan]
        public object startDate { get; set; }

        [Display(Name = "Date de fin")]
        [DisplayFormat(DataFormatString = "{0:dd MMM yyyy}")]
        public object endDate { get; set; }
    }

    [MetadataType(typeof(ProjectMetadata))]
    public partial class Project : IValidatableObject {
        public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
        {
            if (endDate < startDate)
            {
                yield return
                  new ValidationResult(errorMessage: "La date de fin ne peut pas être avant la date de début",
                                       memberNames: new[] { "EndDate" });
            }
        }
    }
}