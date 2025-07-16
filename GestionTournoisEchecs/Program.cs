using BLL.CategoryService;
using DAL.CategoryRepository;
using Microsoft.Data.SqlClient;

namespace API
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // chaine de connexion à la base de données
            string connectionString = builder.Configuration.GetConnectionString("ConnectionStringsP");
            builder.Services.AddSingleton(new SqlConnection(connectionString));

            // Add services to the container.

            builder.Services.AddControllers();


            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();

            // configuration du swagger
            builder.Services.AddSwaggerGen();


            // injection des dépendances
            builder.Services.AddScoped<ICategoryRepository, CategoryRepository>();
            builder.Services.AddScoped<ICategoryService, CategoryService>();


            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }

            app.UseHttpsRedirection();

            app.UseAuthorization();


            app.MapControllers();

            app.Run();
        }
    }
}
