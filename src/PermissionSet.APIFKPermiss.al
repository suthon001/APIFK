permissionset 60050 "API FK Permiss"
{
    Assignable = true;
    Caption = 'API FK Permiss', MaxLength = 30;
    Permissions =
        table "FK API Log" = X,
        tabledata "FK API Log" = RMID,
        table "API Setup Line" = X,
        tabledata "API Setup Line" = RMID,
        table "API Setup Header" = X,
        tabledata "API Setup Header" = RMID,
        codeunit "FK Func" = X,
        page "FK Good ReceiptNote Subpage" = X,
        page "Export Template Subform" = X,
        page "FK Good ReceiptNote List" = X,
        page "FK API Mapping" = X,
        page "FK Good ReceiptNote Card" = X,
        page "FK APi Log Card" = X,
        page "FK API Mapping Card" = X,
        page "FK API Log Entry" = X;
}
