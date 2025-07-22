using Microsoft.Data.SqlClient;

using BLL.CategoryService;
using BLL.GenderService;
using BLL.RoleService;
using BLL.StatusService;

using DAL.CategoryRepository;
using DAL.Gender;
using DAL.RoleRepository;
using DAL.StatusRepository;

namespace API
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // chaine de connexion à la base de données
            string connectionString = builder.Configuration.GetConnectionString("ConnectionStrings");
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
            builder.Services.AddScoped<IGenderRepository, GenderRepository>();
            builder.Services.AddScoped<IGenderService, GenderService>();
            builder.Services.AddScoped<IRoleRepository, RoleRepository>();
            builder.Services.AddScoped<IRoleService, RoleService>();
            builder.Services.AddScoped<IStatusRepository, StatusRepository>();
            builder.Services.AddScoped<IStatusService, StatusService>();

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