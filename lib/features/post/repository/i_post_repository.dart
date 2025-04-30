import 'package:anime_nexa/models/comment.dart';
import 'package:anime_nexa/models/post.dart';
import 'package:anime_nexa/models/reply.dart';

abstract class IPostRepository {
  Stream<List<Post>> getPosts();
  Future<Post> getPostById(String id);
  Future<void> createPost(Post post);
  Future<void> updatePost(Post post);
  Future<void> deletePost(Post post);
  Future<void> likePost(String postId, String userId);
  Future<void> commentOnPost(Comment comment);
  Future<void> deleteComment(Comment comment);
  Future<Comment> getCommentById(String id);
  Future<void> replyToComment(Reply reply);
  Future<void> deleteReply(Reply reply);
  Future<List<Reply>> getReplies(String commentId);
}
