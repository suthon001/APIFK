permissionset 60050 "API FK Permiss"
{
    Assignable = true;
    Caption = 'API FK Permiss', MaxLength = 30;
    Permissions =
        table "API Setup Header" = X,
        tabledata "API Setup Header" = RMID,
        table "API Setup Line" = X,
        tabledata "API Setup Line" = RMID,
        table "API Log" = X,
        tabledata "API Log" = RMID,
        codeunit "FK Func" = X,
        page "FK API Mapping" = X,
        page "FK API Mapping Card" = X,
        page "Export Template Subform" = X,
        page "API Log Entry" = X;
}
