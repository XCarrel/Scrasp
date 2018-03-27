using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Scrasp.Models
{
    public class GreaterThanAttribute : ValidationAttribute
    {

        private string startDate;
        private DateTime today = DateTime.UtcNow;

        public GreaterThanAttribute() { }
        public GreaterThanAttribute(string startDate) {

            this.startDate = startDate;
        }

        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            DateTime dt = (DateTime)value;

            if (dt < this.today)
            {
                return new ValidationResult("La date de début ne peut pas être dans le passé");
            }

            return ValidationResult.Success;
        }

    }
}