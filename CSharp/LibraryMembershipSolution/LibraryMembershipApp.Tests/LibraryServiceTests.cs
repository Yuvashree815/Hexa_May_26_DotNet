using LibraryMembershipApp.Interfaces;
using LibraryMembershipApp.Models;
using LibraryMembershipApp.Services;
using Moq;

namespace LibraryMembershipApp.Tests
{
    [TestFixture]
    public class Tests
    {
        [SetUp]
        public void Setup()
        {
        }

        [Test]
        public void BorrowBook_WhenAllConditionsAreValid_ShouldReturnSuccessMessage()
        {
            //Arrange
            var member = new Member
            {
                MemberId = 1,
                MemberName = "Yuva",
                Email = "yuva@mail.com",
                IsActive=true,
                BorrowedBookCount = 1,
                IsPremiumMember = true,
            };

            var book = new Book
            {
                BookId = 101,
                BookTitle = "Ikigai",
                AuthorName = "Miralles & García",
                IsAvailable = true,
               
            };

            var bookRepositoryMock = new Mock<IBookRepository>();
            var memberRepositoryMock = new Mock<IMemberRepository>();
            var notificationRepositoryMock= new Mock<INotificationService>();

            bookRepositoryMock.Setup(repo => repo.GetBookById(101)).Returns(book);
            memberRepositoryMock.Setup(repo => repo.GetMemberById(1)).Returns(member);

            var libraryService = new LibraryService(memberRepositoryMock.Object,bookRepositoryMock.Object,notificationRepositoryMock.Object ) ;

            // Act
            string result = libraryService.BorrowBook( 1, 101);

            //Assert
            Assert.That(result, Is.EqualTo("Book borrowed successfully"));

            bookRepositoryMock.Verify(b=> b.MarkBookAsBorrowed(101), Times.Once);
            memberRepositoryMock.Verify(m=> m.UpdateBorrowedBookCount(1), Times.Once);
            notificationRepositoryMock.Verify(n => n.SendBorrowNotification("yuva@mail.com", "Ikigai"), Times.Once);
        }
        [Test]
        public void BorrowBook_WhenMemberDoesNotExist_ShouldReturnMemberNotFound()
        {
            //Arrange
            var book = new Book
            {
                BookId = 101,
                BookTitle = "Ikigai",
                AuthorName = "Miralles & García",
                IsAvailable = true,
               
            };

            var bookRepositoryMock = new Mock<IBookRepository>();
            var memberRepositoryMock = new Mock<IMemberRepository>();
            var notificationRepositoryMock = new Mock<INotificationService>();

            bookRepositoryMock.Setup(repo => repo.GetBookById(101)).Returns(book);
            memberRepositoryMock.Setup(repo => repo.GetMemberById(1000)).Returns((Member?)null);

            var libraryService = new LibraryService(memberRepositoryMock.Object, bookRepositoryMock.Object, notificationRepositoryMock.Object);

            // Act
            string result = libraryService.BorrowBook(1000, 101);

            //Assert
            Assert.That(result, Is.EqualTo("Member not found"));

            memberRepositoryMock.Verify(m => m.UpdateBorrowedBookCount(It.IsAny<int>()), Times.Never);
            bookRepositoryMock.Verify(b => b.MarkBookAsBorrowed(It.IsAny<int>()), Times.Never);
            notificationRepositoryMock.Verify(n => n.SendBorrowNotification(It.IsAny<string>(), It.IsAny<string>()), Times.Never);
        }

        [Test]
        public void BorrowBook_WhenMemberIsInactive_ShouldReturnMemberIsNotActive()
        {
            //Arrange
            var member = new Member
            {
                MemberId = 1,
                MemberName = "Yuva",
                Email = "yuva@mail.com",
                IsActive = false,
                BorrowedBookCount = 1,
                IsPremiumMember = true
            };
            var book = new Book
            {
                BookId = 101,
                BookTitle = "Ikigai",
                AuthorName = "Miralles & García",
                IsAvailable = true
            };
            var bookRepositoryMock = new Mock<IBookRepository>();
            var memberRepositoryMock = new Mock<IMemberRepository>();
            var notificationRepositoryMock = new Mock<INotificationService>();

            bookRepositoryMock.Setup(repo => repo.GetBookById(101)).Returns(book);
            memberRepositoryMock.Setup(repo => repo.GetMemberById(1)).Returns(member);

            var libraryService = new LibraryService(memberRepositoryMock.Object, bookRepositoryMock.Object, notificationRepositoryMock.Object);

            // Act
            string result = libraryService.BorrowBook(1, 101);

            //Assert
            Assert.That(result, Is.EqualTo("Member is not active"));

            memberRepositoryMock.Verify(m => m.UpdateBorrowedBookCount(It.IsAny<int>()), Times.Never);
            bookRepositoryMock.Verify(b => b.MarkBookAsBorrowed(It.IsAny<int>()), Times.Never);
            notificationRepositoryMock.Verify(n => n.SendBorrowNotification(It.IsAny<string>(), It.IsAny<string>()), Times.Never);

        }

        [Test]
        public void BorrowBook_WhenBookDoesNotExist_ShouldReturnBookNotFound()
        {
            //Arrange
            var member = new Member
            {
                MemberId = 1,
                MemberName = "Yuva",
                Email = "yuva@mail.com",
                IsActive = true,
                BorrowedBookCount = 1,
                IsPremiumMember = true
            };
            var bookRepositoryMock = new Mock<IBookRepository>();
            var memberRepositoryMock = new Mock<IMemberRepository>();
            var notificationRepositoryMock = new Mock<INotificationService>();

            bookRepositoryMock.Setup(repo => repo.GetBookById(1000)).Returns((Book?)null);
            memberRepositoryMock.Setup(repo => repo.GetMemberById(1)).Returns(member);

            var libraryService = new LibraryService(memberRepositoryMock.Object, bookRepositoryMock.Object, notificationRepositoryMock.Object);

            // Act
            string result = libraryService.BorrowBook(1, 1000);

            //Assert
            Assert.That(result, Is.EqualTo("Book not found"));

            memberRepositoryMock.Verify(m => m.UpdateBorrowedBookCount(It.IsAny<int>()), Times.Never);
            bookRepositoryMock.Verify(b => b.MarkBookAsBorrowed(It.IsAny<int>()), Times.Never);
            notificationRepositoryMock.Verify(n => n.SendBorrowNotification(It.IsAny<string>(), It.IsAny<string>()), Times.Never);

        }

        [Test]
        public void BorrowBook_WhenBookIsNotAvailable_ShouldReturnBookIsNotAvailable()
        {
            //Arrange
            var member = new Member
            {
            MemberId = 1,
                MemberName = "Yuva",
                Email = "yuva@mail.com",
                IsActive = true,
                BorrowedBookCount = 1,
                IsPremiumMember = true
            };
        var book = new Book
        {
            BookId = 101,
            BookTitle = "Ikigai",
            AuthorName = "Miralles & García",
            IsAvailable = false
        };
        var bookRepositoryMock = new Mock<IBookRepository>();
        var memberRepositoryMock = new Mock<IMemberRepository>();
        var notificationRepositoryMock = new Mock<INotificationService>();

        bookRepositoryMock.Setup(repo => repo.GetBookById(101)).Returns(book);
        memberRepositoryMock.Setup(repo => repo.GetMemberById(1)).Returns(member);

        var libraryService = new LibraryService(memberRepositoryMock.Object, bookRepositoryMock.Object, notificationRepositoryMock.Object);

        // Act
        string result = libraryService.BorrowBook(1, 101);

        //Assert
        Assert.That(result, Is.EqualTo("Book is not available"));

            memberRepositoryMock.Verify(m => m.UpdateBorrowedBookCount(It.IsAny<int>()), Times.Never);
            bookRepositoryMock.Verify(b => b.MarkBookAsBorrowed(It.IsAny<int>()), Times.Never);
            notificationRepositoryMock.Verify(n => n.SendBorrowNotification(It.IsAny<string>(), It.IsAny<string>()), Times.Never);
        }

        [Test]
        public void BorrowBook_WhenBorrowingLimitReached_ShouldReturnBorrowingLimitReached()
        {
            //Arrange
            var member = new Member
            {
                MemberId = 1,
                MemberName = "Yuva",
                Email = "yuva@mail.com",
                IsActive = true,
                BorrowedBookCount = 3,
                IsPremiumMember=false
            };
            var book = new Book
            {
                BookId = 101,
                BookTitle = "Ikigai",
                AuthorName = "Miralles & García",
                IsAvailable = true
            };
            var bookRepositoryMock = new Mock<IBookRepository>();
            var memberRepositoryMock = new Mock<IMemberRepository>();
            var notificationRepositoryMock = new Mock<INotificationService>();

            bookRepositoryMock.Setup(repo => repo.GetBookById(101)).Returns(book);
            memberRepositoryMock.Setup(repo => repo.GetMemberById(1)).Returns(member);

            var libraryService = new LibraryService(memberRepositoryMock.Object, bookRepositoryMock.Object, notificationRepositoryMock.Object);

            // Act
            string result = libraryService.BorrowBook(1, 101);

            //Assert
            Assert.That(result, Is.EqualTo("Borrowing limit reached"));

            memberRepositoryMock.Verify(m => m.UpdateBorrowedBookCount(It.IsAny<int>()), Times.Never);
            bookRepositoryMock.Verify(b => b.MarkBookAsBorrowed(It.IsAny<int>()), Times.Never);
            notificationRepositoryMock.Verify(n => n.SendBorrowNotification(It.IsAny<string>(), It.IsAny<string>()), Times.Never);

        }

        [Test]
        public void BorrowBook_WhenMemberIdIsInvalid_ShouldReturnInvalidMemberId()
        {
            //Arrange
            var member = new Member
            {
                MemberId = 0,
                MemberName = "Yuva",
                Email = "yuva@mail.com",
                IsActive = true,
                BorrowedBookCount = 1,
                IsPremiumMember = true
            };
            var book = new Book
            {
                BookId = 101,
                BookTitle = "Ikigai",
                AuthorName = "Miralles & García",
                IsAvailable = true
            };
            var bookRepositoryMock = new Mock<IBookRepository>();
            var memberRepositoryMock = new Mock<IMemberRepository>();
            var notificationRepositoryMock = new Mock<INotificationService>();

            

            var libraryService = new LibraryService(memberRepositoryMock.Object, bookRepositoryMock.Object, notificationRepositoryMock.Object);

            // Act
            string result = libraryService.BorrowBook(0, 101);

            //Assert
            Assert.That(result, Is.EqualTo("Invalid member id"));

            memberRepositoryMock.Verify(repo => repo.GetMemberById(It.IsAny<int>()));
            bookRepositoryMock.Verify(repo=> repo.GetBookById(It.IsAny<int>()));
            memberRepositoryMock.Verify(m => m.UpdateBorrowedBookCount(It.IsAny<int>()), Times.Never);
            bookRepositoryMock.Verify(b => b.MarkBookAsBorrowed(It.IsAny<int>()), Times.Never);
            notificationRepositoryMock.Verify(n => n.SendBorrowNotification(It.IsAny<string>(), It.IsAny<string>()), Times.Never);


        }

        [Test]
        public void BorrowBook_WhenBookIdIsInvalid_ShouldReturnInvalidBookId()
        {
            //Arrange
            var member = new Member
            {
                MemberId = 1,
                MemberName = "Yuva",
                Email = "yuva@mail.com",
                IsActive = true,
                BorrowedBookCount = 1,
                IsPremiumMember = true
            };
            var book = new Book
            {
                BookId = 0,
                BookTitle = "Ikigai",
                AuthorName = "Miralles & García",
                IsAvailable = true
            };
            var bookRepositoryMock = new Mock<IBookRepository>();
            var memberRepositoryMock = new Mock<IMemberRepository>();
            var notificationRepositoryMock = new Mock<INotificationService>();



            var libraryService = new LibraryService(memberRepositoryMock.Object, bookRepositoryMock.Object, notificationRepositoryMock.Object);

            // Act
            string result = libraryService.BorrowBook(1, 0);

            //Assert
            Assert.That(result, Is.EqualTo("Invalid book id"));

            memberRepositoryMock.Verify(repo => repo.GetMemberById(It.IsAny<int>()));
            bookRepositoryMock.Verify(repo => repo.GetBookById(It.IsAny<int>()));
            memberRepositoryMock.Verify(m => m.UpdateBorrowedBookCount(It.IsAny<int>()), Times.Never);
            bookRepositoryMock.Verify(b => b.MarkBookAsBorrowed(It.IsAny<int>()), Times.Never);
            notificationRepositoryMock.Verify(n => n.SendBorrowNotification(It.IsAny<string>(), It.IsAny<string>()), Times.Never);

        }

        [Test]
        public void BorrowBook_WhenNormalMemberHasThreeBooks_ShouldReturnBorrowingLimitReached()
        {
            //Arrange
            var member = new Member
            {
                MemberId = 1,
                MemberName = "Yuva",
                Email = "yuva@mail.com",
                IsActive = true,
                BorrowedBookCount = 3,
                IsPremiumMember = false

            };
            var book = new Book
            {
                BookId = 101,
                BookTitle = "Ikigai",
                AuthorName = "Miralles & García",
                IsAvailable = true
            };
            var bookRepositoryMock = new Mock<IBookRepository>();
            var memberRepositoryMock = new Mock<IMemberRepository>();
            var notificationRepositoryMock = new Mock<INotificationService>();

            bookRepositoryMock.Setup(repo => repo.GetBookById(101)).Returns(book);
            memberRepositoryMock.Setup(repo => repo.GetMemberById(1)).Returns(member);

            var libraryService = new LibraryService(memberRepositoryMock.Object, bookRepositoryMock.Object, notificationRepositoryMock.Object);

            // Act
            string result = libraryService.BorrowBook(1, 101);

            //Assert
            Assert.That(result, Is.EqualTo("Borrowing limit reached"));

            memberRepositoryMock.Verify(m => m.UpdateBorrowedBookCount(It.IsAny<int>()), Times.Never);
            bookRepositoryMock.Verify(b => b.MarkBookAsBorrowed(It.IsAny<int>()), Times.Never);
            notificationRepositoryMock.Verify(n => n.SendBorrowNotification(It.IsAny<string>(), It.IsAny<string>()), Times.Never);


        }

        [Test]
        public void BorrowBook_WhenPremiumMemberHasThreeBooks_ShouldAllowBorrowing()
        {
            //Arrange
            var member = new Member
            {
            MemberId = 1,
                MemberName = "Yuva",
                Email = "yuva@mail.com",
                IsActive = true,
                BorrowedBookCount = 3,
                IsPremiumMember = true

            };
        var book = new Book
        {
            BookId = 101,
            BookTitle = "Ikigai",
            AuthorName = "Miralles & García",
            IsAvailable = true
        };
        var bookRepositoryMock = new Mock<IBookRepository>();
        var memberRepositoryMock = new Mock<IMemberRepository>();
        var notificationRepositoryMock = new Mock<INotificationService>();

        bookRepositoryMock.Setup(repo => repo.GetBookById(101)).Returns(book);
        memberRepositoryMock.Setup(repo => repo.GetMemberById(1)).Returns(member);

        var libraryService = new LibraryService(memberRepositoryMock.Object, bookRepositoryMock.Object, notificationRepositoryMock.Object);

        // Act
        string result = libraryService.BorrowBook(1, 101);

        //Assert
        Assert.That(result, Is.EqualTo("Book borrowed successfully"));

            bookRepositoryMock.Verify(b => b.MarkBookAsBorrowed(101), Times.Once);
            memberRepositoryMock.Verify(m => m.UpdateBorrowedBookCount(1), Times.Once);
            notificationRepositoryMock.Verify(n => n.SendBorrowNotification("yuva@mail.com", "Ikigai"), Times.Once);
        

        }

        [Test]
        public void BorrowBook_WhenPremiumMemberHasFiveBooks_ShouldReturnBorrowingLimitReached()
        {
            //Arrange
            var member = new Member
            {
                MemberId = 1,
                MemberName = "Yuva",
                Email = "yuva@mail.com",
                IsActive = true,
                BorrowedBookCount = 5,
                IsPremiumMember = true

            };
            var book = new Book
            {
                BookId = 101,
                BookTitle = "Ikigai",
                AuthorName = "Miralles & García",
                IsAvailable = true
            };
            var bookRepositoryMock = new Mock<IBookRepository>();
            var memberRepositoryMock = new Mock<IMemberRepository>();
            var notificationRepositoryMock = new Mock<INotificationService>();

            bookRepositoryMock.Setup(repo => repo.GetBookById(101)).Returns(book);
            memberRepositoryMock.Setup(repo => repo.GetMemberById(1)).Returns(member);

            var libraryService = new LibraryService(memberRepositoryMock.Object, bookRepositoryMock.Object, notificationRepositoryMock.Object);

            // Act
            string result = libraryService.BorrowBook(1, 101);

            //Assert
            Assert.That(result, Is.EqualTo("Borrowing limit reached"));

            memberRepositoryMock.Verify(m => m.UpdateBorrowedBookCount(It.IsAny<int>()), Times.Never);
            bookRepositoryMock.Verify(b => b.MarkBookAsBorrowed(It.IsAny<int>()), Times.Never);
            notificationRepositoryMock.Verify(n => n.SendBorrowNotification(It.IsAny<string>(), It.IsAny<string>()), Times.Never);


        }
        [Test]
        public void BorrowBook_WhenAllConditionsAreValid_ShouldSendNotificationWithCorrectValues()
        {
            //Arrange
            var member = new Member
            {
                MemberId = 1,
                MemberName = "Yuva",
                Email = "yuva@mail.com",
                IsActive = true,
                BorrowedBookCount = 1,
                IsPremiumMember = true,
            };

            var book = new Book
            {
                BookId = 101,
                BookTitle = "Ikigai",
                AuthorName = "Miralles & García",
                IsAvailable = true,

            };

            var bookRepositoryMock = new Mock<IBookRepository>();
            var memberRepositoryMock = new Mock<IMemberRepository>();
            var notificationRepositoryMock = new Mock<INotificationService>();

            bookRepositoryMock.Setup(repo => repo.GetBookById(101)).Returns(book);
            memberRepositoryMock.Setup(repo => repo.GetMemberById(1)).Returns(member);

            var libraryService = new LibraryService(memberRepositoryMock.Object, bookRepositoryMock.Object, notificationRepositoryMock.Object);

            // Act
            string result = libraryService.BorrowBook(1, 101);

            //Assert
            
            notificationRepositoryMock.Verify(n => n.SendBorrowNotification("yuva@mail.com", "Ikigai"), Times.Once);

        }

    }
}

