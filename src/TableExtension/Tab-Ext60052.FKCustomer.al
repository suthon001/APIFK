/// <summary>
/// TableExtension FK Customer (ID 60051) extends Record Customer.
/// </summary>
tableextension 60052 "FK Customer" extends Customer
{
    fields
    {
        field(70000; "Already Send"; Boolean)
        {
            Caption = 'Already Send';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
