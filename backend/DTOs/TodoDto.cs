using System.ComponentModel.DataAnnotations;

namespace TodoApi.DTOs;

// Pagination Request DTO
public class PaginationDto
{
    private const int MaxPageSize = 100;
    private int _pageSize = 10;

    public int PageNumber { get; set; } = 1;

    public int PageSize
    {
        get => _pageSize;
        set => _pageSize = (value > MaxPageSize) ? MaxPageSize : value;
    }
}

// Paginated Response DTO
public class PaginatedResponseDto<T>
{
    public IEnumerable<T> Items { get; set; } = new List<T>();
    public int PageNumber { get; set; }
    public int PageSize { get; set; }
    public int TotalPages { get; set; }
    public int TotalCount { get; set; }
    public bool HasPrevious => PageNumber > 1;
    public bool HasNext => PageNumber < TotalPages;
}

public class CreateTodoDto
{
    [Required]
    [MaxLength(1000)]
    public string Text { get; set; } = string.Empty;
}

public class UpdateTodoDto
{
    [Required]
    [MaxLength(1000)]
    public string Text { get; set; } = string.Empty;

    public bool Completed { get; set; }
}

public class TodoDto
{
    public int Id { get; set; }
    public string Text { get; set; } = string.Empty;
    public bool Completed { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public int UserId { get; set; }
}
