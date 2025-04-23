import Foundation
import CoreData

@objc(User)
final class User: NSManagedObject, Identifiable {
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var provider: String?
    @NSManaged public var accessToken: String?
    @NSManaged public var refreshToken: String?
    @NSManaged public var expiresIn: Date?
}

extension User {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        NSFetchRequest<User>(entityName: "User")
    }
}
