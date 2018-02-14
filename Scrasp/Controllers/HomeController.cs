using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Scrasp.Controllers
{
    public class HomeController : Controller
    {
        private List<string> todo;

        public HomeController()
        {
            todo = getTodoList();
            ViewBag.Todo = todo;
        }

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Scrasp, un outil de gestion de projet Scrum developpé sur ASP MVC par la classe SI-T2a de 2018";
            return View();
        }

        public ActionResult Add()
        {
            // Préparez vos données comme dans la méthode Index
            List<string> todo = getTodoList();
            ViewBag.Todo = todo;

            // Ajoutez-y un utilisateur supplémentaire
            // ...
            ViewBag.Message = "Utilisateur ajouté";
            return View("Index");
        }

        public ActionResult Rename(int id)
        {
            // Préparez vos données comme dans la méthode Index
            List<string> todo = getTodoList();
            ViewBag.Todo = todo;

            // Ajoutez-y un utilisateur supplémentaire
            // ...
            ViewBag.Message = string.Format("Utilisateur {0} renommé",id);
            return View("Index");
        }

        private List<string> getTodoList()
        {
            return 
                new List<string>(new string[] {
                    "Coder les classes décrites dans le modèle Scrasp.asta",
                    "Instancier des objets Story, Task et User hardcodés dans HomeController.Index, les mettre dans des listes, les passer à la vue avec le ViewBag et les afficher dans la section Données ci-dessous",
                    "Compléter HomeController.Add() et Index.cshtml pour faire fonctionner l'ajout d'un utilisateur (premier lien dans les actions ci-dessous)",
                    "Faire de même pour le renommage (deuxième lien lien dans les actions ci-dessous). Observer la différence des routes et méthodes (passage de paramètre)",
                    "Modifier App_Start/RouteConfig.cs pour configurer les routes supplémentaires delete et changeid. Créer les méthodes nécessaires dans HomeController et modifier Index.cshtml pour faire fonctionner les liens de suppression et de modification",
                    "Autoriser la modification de l'attribut id avec une auto-property dans IdentifiableEntity. L'attribut statique lastId prendra la valeur d'id donnée",
                    "Modifier IdentifiableEntity de telle sorte qu'elle lève une exception si l'application tente de changer l'id d'un objet à une valeur inférieure ou égale à lastId. Choisissez la bonne exception en vous appuyant sur https://docs.microsoft.com/en-us/dotnet/standard/exceptions/best-practices-for-exceptions",
                    "Soumettre vos questions au moyen d'issues dans le repo Git"
                });
        }

    }
}