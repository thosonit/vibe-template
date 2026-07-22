/// Shared per-action async status, used by viewmodels with multiple
/// independent actions (Pattern 2 in the architecture doc). Imported
/// across features — do not redefine per feature.
enum LoadStatus { initial, loading, success, failure }
