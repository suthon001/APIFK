/// <summary>
/// Query FK Grouping Get PR (ID 60050).
/// </summary>
query 60050 "FK Grouping Get PR"
{
    QueryType = Normal;
    Caption = 'Group Get PR. Line';
    elements
    {
        dataitem(Purchase_Line; "Purchase Line")
        {
            column(Document_Type; "Document Type") { }
            column(Document_No_; "Document No.") { }
            column(Reference_PR_No_; "TPP Reference PR No.") { }
            column(Quantity; Quantity)
            {

                Method = Sum;

            }

        }
    }
}